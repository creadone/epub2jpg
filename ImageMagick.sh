cat <<EOF > /etc/profile.d/ImageMagick.sh
# Set ImageMagick memory limits: it eats too much
export MAGICK_MEMORY_LIMIT=1024 # Use up to *MB of memory before doing mmap
export MAGICK_MAP_LIMIT=1024    # Use up to *MB mmaps before caching to disk
export MAGICK_AREA_LIMIT=4096   # Use up to *MB disk space before failure
export MAGICK_FILES_LIMIT=1024  # Don't open more than *file handles
EOF
