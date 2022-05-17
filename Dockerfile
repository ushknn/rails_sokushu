FROM ruby:3.0.4

# yarnインストール時のバージョンを指定
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# パッケージリスト更新後、railsとDBに必要なパッケージインストール
RUN apt-get update && apt-get install -y nodejs postgresql-client yarn

RUN CHROME_DRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/ && \
    rm ~/chromedriver_linux64.zip && \
    chown root:root ~/chromedriver && \
    chmod 755 ~/chromedriver && \
    mv ~/chromedriver /usr/local/bin/chromedriver && \
    sh -c 'wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -' && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

# /usr/src/appを作業ディレクトリとし、Gemfile Gemfile.lockをコピーする
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./

# コピーしたGemfile Gemfile.lockに書いてあるGemをinstallする
RUN bundle install

# railsのアプリを含め、すべてのファイルをコピー
COPY . ./