FROM gcr.io/distroless/cc-debian12

COPY obscura /usr/local/bin/obscura

EXPOSE 9222
ENTRYPOINT ["/usr/local/bin/obscura"]
CMD ["serve", "--port", "9222"]