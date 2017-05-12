FROM elixir:1.4.2
MAINTAINER dsinelnikov96@gmail.com

ENV MIX_ENV=prod
ENV APP_HOME=/app

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY mix.exs $APP_HOME/
COPY mix.lock $APP_HOME/
RUN mix local.hex --force && mix local.rebar --force && \
    mix deps.get && mix deps.compile

COPY . $APP_HOME
RUN mix compile

CMD ["mix", "run", "--no-halt"]
