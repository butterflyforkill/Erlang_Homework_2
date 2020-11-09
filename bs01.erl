%%1> BinText = <<"Some text">>.
%%<<"Some Text">>
%%2> bs01:first_word(BinText).
%%<<”Some”>>


-module(bs01).
-export([first_word/1]).

first_word(B)->
    first_word(B,<<>>).

first_word(<<" ",_Rest/binary>>,Acc)->
        Acc;
first_word(<<X/utf8, Rest/binary>>,Acc)->
    first_word(Rest,<<Acc/binary,X/utf8>>);

first_word(<<>>, Acc)->Acc.

