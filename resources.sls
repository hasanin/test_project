# Ensure the existence of /var/www/html dir
html_dir:
  file.directory:
    - name: /var/www/html
    - makedirs: True
# Copy the index.php file to /var/www/html dir
php_file:
  file.managed:
    - name: /var/www/html/index.php
    - source: salt://resources/index.php
    - makedirs: True