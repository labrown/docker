POSTCONF=/usr/sbin/postconf

config_dir=$($POSTCONF -h config_directory)
# see if anything is running chrooted.
NEED_CHROOT=$(awk '/^[0-9a-z]/ && ($5 ~ "[-yY]") { print "y"; exit}' ${config_dir}/master.cf)

if [ -n "$NEED_CHROOT" ]; then
# Make sure that the chroot environment is set up correctly.
oldumask=$(umask)
umask 022
queue_dir=$($POSTCONF -h queue_directory)
cd "$queue_dir"

# copy the CA path if specified
ca_path=$($POSTCONF -h smtp_tls_CApath)
case "$ca_path" in
    '') :;; # no ca_path
    $queue_dir/*) :;;  # skip stuff already in chroot
    *)
	if test -d "$ca_path"; then
	    dest_dir="$queue_dir/${ca_path#/}"
	    new=0
	    if test -d "$dest_dir"; then
		# write to a new directory ...
		dest_dir="${dest_dir%/}.NEW"
		new=1
	    else
		mkdir --parent ${dest_dir%/*}
	    fi
	    # handle files in subdirectories
	    (cd "$ca_path" && find . -name '*.pem' -print0 | cpio -0pdL --quiet "$dest_dir") 2>/dev/null || 
		(echo "failure copying certificates"; exit 1)
	    c_rehash "$dest_dir" >/dev/null 2>&1
	    if [ "$new" = 1 ]; then
		# and replace the old directory
		rm -r "${dest_dir%.NEW}"
		mv "$dest_dir" "${dest_dir%.NEW}"
	    fi
	fi
	;;
esac

# if there is a CA file, copy it
ca_file=$($POSTCONF -h smtp_tls_CAfile)
case "$ca_file" in
    $queue_dir/*) :;;  # skip stuff already in chroot
    '') # no ca_file
	# or copy the bundle to preserve functionality
	ca_bundle=/etc/ssl/certs/ca-certificates.crt
	if [ -f $ca_bundle ]; then
	    mkdir --parent "$queue_dir/${ca_bundle%/*}"
	    cp -L "$ca_bundle" "$queue_dir/${ca_bundle%/*}"
	fi
	;;
    *)
	if test -f "$ca_file"; then
	    dest_dir="$queue_dir/${ca_path#/}"
	    mkdir --parent "$dest_dir"
	    cp -L "$ca_file" "$dest_dir"
	fi
	;;
esac

# if we're using unix:passwd.byname, then we need to add etc/passwd.
local_maps=$($POSTCONF -h local_recipient_maps)
if [ "X$local_maps" != "X${local_maps#*unix:passwd.byname}" ]; then
    if [ "X$local_maps" = "X${local_maps#*proxy:unix:passwd.byname}" ]; then
	sed 's/^\([^:]*\):[^:]*/\1:x/' /etc/passwd > etc/passwd
	chmod a+r etc/passwd
    fi
fi

FILES="etc/localtime etc/services etc/resolv.conf etc/hosts \
    etc/nsswitch.conf etc/nss_mdns.config"
for file in $FILES; do
    [ -d ${file%/*} ] || mkdir -p ${file%/*}
    if [ -f /${file} ]; then rm -f ${file} && cp /${file} ${file}; fi
    if [ -f  ${file} ]; then chmod a+rX ${file}; fi
done
# ldaps needs this. debian bug 572841
(echo /dev/random; echo /dev/urandom) | cpio -pdL --quiet . 2>/dev/null || true
rm -f usr/lib/zoneinfo/localtime
mkdir -p usr/lib/zoneinfo
ln -sf /etc/localtime usr/lib/zoneinfo/localtime

LIBLIST=$(for name in gcc_s nss resolv; do
    for f in /lib/*/lib${name}*.so* /lib/lib${name}*.so*; do
       if [ -f "$f" ]; then  echo ${f#/}; fi;
    done;
done)

if [ -n "$LIBLIST" ]; then
    for f in "$LIBLIST"; do
	rm -f "$f"
    done
    tar cf - -C / $LIBLIST 2>/dev/null |tar xf -
fi
umask $oldumask
fi
