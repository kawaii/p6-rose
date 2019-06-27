FROM rakudo-star:2019.03

ARG BUILD_AUTHORS
ARG BUILD_DATE
ARG BUILD_SHA1SUM
ARG BUILD_VERSION

LABEL org.opencontainers.image.authors=$BUILD_AUTHORS \
      org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.version=$BUILD_VERSION

RUN set -ex; \
	\
	savedAptMark="$(apt-mark showmanual)"; \
	\
	apt-get update; \
	apt-get install -y --no-install-recommends \
		build-essential \
		libpq5 \
		libpq-dev \
		libssl1.0-dev \
	; \
	apt-get clean; \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
	; \
	zef install --/test \
		API::Discord \
		API::Perspective \
		Command::Despatch \
		DB::Pg \
		JSON::Fast

ENV ROSE_VERSION $BUILD_VERSION
ENV ROSE_SHA1 $BUILD_SHA1SUM

WORKDIR /opt/perl6/rose/

RUN set -ex; \
	curl -o rose.tar.gz -fSL "https://github.com/kawaii/p6-rose/archive/${ROSE_VERSION}.tar.gz"; \
	echo "$ROSE_SHA1 *rose.tar.gz" | sha1sum -c -; \
	tar -xzf rose.tar.gz -C /usr/src/; \
	rm rose.tar.gz

COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["perl6", "-I", "lib/", "rose.p6"]
