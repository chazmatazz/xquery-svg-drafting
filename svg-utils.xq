(: Utility functions for svg microsyntax generation :) 
module namespace svg-utils = 'http://www.charlesdietrich.com/svg-utils';

import module namespace math = "http://www.w3.org/2005/xpath-functions/math";

declare function svg-utils:rad-to-deg($rad as xs:double) as xs:integer {
    xs:integer(180 * $rad div math:pi())
};

declare function svg-utils:M($x as xs:double, $y as xs:double) as xs:string {
    concat("M ", xs:integer($x), ",", xs:integer($y))
};

declare function svg-utils:A($rx as xs:double, $ry as xs:double, $x-axis-rotation as xs:double, 
    $large-arc-flag as xs:integer, $sweep-flag as xs:integer, 
    $x as xs:double, $y as xs:double) as xs:string {
    concat("A ", xs:integer($rx), ",", xs:integer($ry), " ", $x-axis-rotation, " ",
        $large-arc-flag, ",", $sweep-flag, " ", xs:integer($x), ",", xs:integer($y))
};

declare function svg-utils:L($ps as xs:double*) as xs:string {
    concat("L ", string-join({for $i in (1 to xs:integer((count($ps) div 2)))
                                return concat(xs:integer($ps[2 * $i - 1]), ",", xs:integer($ps[2 * $i]))}, " "))
};

declare function svg-utils:L($x as xs:double, $y as xs:double) as xs:string {
    concat("L ", xs:integer($x), ",", xs:integer($y))
};

declare function svg-utils:H($x as xs:double) as xs:string {
    concat("H ", xs:integer($x))
};

declare function svg-utils:V($y as xs:double) as xs:string {
    concat("V ", xs:integer($y))
};

declare function svg-utils:Z() as xs:string {
    "Z"
};

declare function svg-utils:path($commands as xs:string*) as xs:string {
    string-join($commands, " ")
};

declare function svg-utils:rotate($deg as xs:double) as xs:string {
    concat("rotate(", xs:integer($deg), ")")
};

declare function svg-utils:transform($ts as xs:string*) as xs:string {
    string-join($ts, " ")
};

declare function svg-utils:translate($x as xs:double) as xs:string {
    concat("translate(", xs:integer($x), ")")
};

declare function svg-utils:translate($x as xs:double, $y as xs:double) as xs:string {
    concat("translate(", xs:integer($x), ",", xs:integer($y),")")
};

declare function svg-utils:scale($s as xs:double) as xs:string {
    concat("scale(", $s, ")")
};

declare function svg-utils:scale($sx as xs:double, $sy as xs:double) as xs:string {
    concat("scale(", $sx, ",", $sy,")")
};