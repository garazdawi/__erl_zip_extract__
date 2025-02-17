-module(zip_extract_test).

-export([main/1]).

main(_Argv) ->
  application:ensure_all_started(inets),
  application:ensure_all_started(ssl),

  case file:read_file_info(filelib:wildcard("tmp/ImageMagick*")) of
    {error, _} ->
      file:del_dir_r("tmp"),
      file:make_dir("tmp"),

      io:format("Downloading the archive~n"),
      Url = "https://imagemagick.org/archive/binaries/ImageMagick-7.1.0-portable-Q16-x64.zip",
      {ok, {{_, 200, _}, _, Body}} = httpc:request(get, {Url, []}, [], []),
      file:write_file("tmp/ImageMagick-7.1.0-portable-Q16-x64.zip", Body);
    {ok, _} ->
      ok
  end,

  io:format("Unzipping~n"),

  dbg:tracer(),dbg:p(all,[call, arity]),
  dbg:tp(zlib,[]),
  dbg:tpl(zip, get_z_data, x),
  {ok, _Paths} = zip:extract("tmp/ImageMagick-7.1.0-portable-Q16-x64.zip", [{cwd, "tmp/extract"}]).
