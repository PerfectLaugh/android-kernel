FROM library/debian:12-slim

RUN apt-get update && apt-get install -y \
  git rsync \
  curl \
  python3 \
  openssh-client \
  bash \
  && rm -rf /var/lib/apt/lists/*
RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /usr/local/bin/repo && chmod a+x /usr/local/bin/repo

# Fix 'curl: (26) .netrc error: no such file'
# RUN touch ~/.netrc

RUN git config --global user.email "unknown@unknown.com" && \
  git config --global user.name "Unknown" && \
  git config --global color.ui false

RUN useradd -ms /bin/bash user
