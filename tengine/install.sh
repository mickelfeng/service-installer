#!/bin/sh

source ./conf.sh

cd $SRC_ROOT_PATH;

NGINX_SRC=nginx-1.2.5
rm -rf $NGINX_SRC
tar zxvf $NGINX_SRC.tar.gz
rm -rf pcre-8.12
tar zxvf pcre-8.12.tar.gz

#tar third modules
cd $SRC_ROOT_PATH"/third_mod"
rm -rf headers-more-nginx-module
tar -zxvf headers-more-nginx-module.tar.gz
rm -rf taobao-nginx-http-concat
tar -xzvf taobao-nginx-http-concat.tar.gz

cd $SRC_ROOT_PATH/$NGINX_SRC

make clean
./configure \
    --prefix=$INSTALL_PATH  \
    --with-pcre=$SRC_ROOT_PATH"/pcre-8.12" \
    --http-log-path=$INSTALL_PATH"/logs/access_log" \
    --error-log-path=$INSTALL_PATH"/logs/error_log" \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --http-client-body-temp-path=$INSTALL_PATH"/cache/client_body" \
    --http-proxy-temp-path=$INSTALL_PATH"/cache/proxy" \
    --http-fastcgi-temp-path=$INSTALL_PATH"/cache/fastcgi" \
    --http-uwsgi-temp-path=$INSTALL_PATH"/cache/uwsgi" \
    --http-scgi-temp-path=$INSTALL_PATH"/cache/scgi" \
    --add-module=$SRC_ROOT_PATH"/third_mod/headers-more-nginx-module" \
    --add-module=$SRC_ROOT_PATH"/third_mod/taobao-nginx-http-concat"
make 
make install

echo "make done!";
cd $SRC_ROOT_PATH"/../"
#mkdir & cp conf
rm -rf $INSTALL_PATH"/cache/"
mkdir $INSTALL_PATH"/cache/"
cp -r conf/* $INSTALL_PATH"/conf/"
sed -e "s:/home/worker:$HOME_PATH:g" -i $INSTALL_PATH"/conf/nginx.conf"
sed -e "s:/home/worker:$HOME_PATH:g" -i $INSTALL_PATH"/conf/nginx.conf.proxy"
cp src/rotate_log.sh $INSTALL_PATH"/sbin/" && chmod 0755 $INSTALL_PATH"/sbin/rotate_log.sh"
