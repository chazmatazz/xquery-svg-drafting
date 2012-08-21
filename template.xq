(: project template :)
declare default element namespace "http://www.w3.org/2000/svg";

declare namespace svg = "http://www.w3.org/2000/svg";

declare namespace xlink = "http://www.w3.org/1999/xlink";

declare namespace cone-sphere = "http://www.charlesdietrich.com/cone-sphere";

import module namespace math = "http://www.w3.org/2005/xpath-functions/math";

import module namespace svg-utils="http://www.charlesdietrich.com/svg-utils" at "svg-utils.xq";

let $svg-width := 100
let $svg-height := 100

return
<svg version="1.1"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     baseProfile="full" width="{$svg-width}" height="{$svg-height}">     
     <style type="text/css">
        .guide {{ stroke: red; fill: none; }}
        .valley-fold {{ stroke: black; stroke-dasharray: 9, 5; fill:none; }}
        .mountain-fold {{ stroke: black; stroke-dasharray: 9, 5, 3, 5; fill: none; }}
        .cut {{ stroke:black; fill: none; }}
     </style>
</svg>