

docker run -p 8283:8283 \
  -e OPENAI_API_BASE=https://openrouter.ai/api/v1 \
  -e OPENAI_API_KEY=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 \
  -e LETTA_PG_URI= \
  -e LETTA_BASE_URL=http://letta:8283 \
  -e ADONIS_HOST=http://navigator-api:3333 \
  navigator-letta