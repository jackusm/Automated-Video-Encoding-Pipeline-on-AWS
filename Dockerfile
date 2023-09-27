FROM amazonlinux:latest
RUN yum -y upgrade -qq && yum -y install \
      wget \
      tar \
      xz
RUN yum -y install unzip aws-cli python3 python3-pip gcc 
RUN pip3 install boto3 ffmpy
ADD encoding_script.py /usr/local/bin/encoding_script.py
RUN chmod +x /usr/local/bin/encoding_script.py
COPY ffmpeg-release-arm64-static.tar.xz .
RUN tar xf ffmpeg-release-arm64-static.tar.xz
RUN cp ffmpeg-6.0-arm64-static/ffmpeg /usr/local/bin/ && \
      cp ffmpeg-6.0-arm64-static/ffprobe /usr/local/bin/ && \
      cp ffmpeg-6.0-arm64-static/qt-faststart /usr/local/bin/ && \
      rm -rf ffmpeg-6.0-arm64-static/
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN source "$HOME/.cargo/env" && \
      ~/.cargo/bin/cargo install ab-av1
WORKDIR /tmp
USER nobody
ENTRYPOINT ["/usr/local/bin/encoding_script.py"]
