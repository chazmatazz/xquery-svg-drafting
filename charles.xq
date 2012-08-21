(: Demo for project 1 :)
declare default element namespace "http://www.w3.org/2000/svg";

declare namespace svg = "http://www.w3.org/2000/svg";

declare namespace xlink = "http://www.w3.org/1999/xlink";

declare namespace cone-sphere = "http://www.charlesdietrich.com/cone-sphere";

import module namespace math = "http://www.w3.org/2005/xpath-functions/math";

import module namespace svg-utils="http://www.charlesdietrich.com/svg-utils" at "svg-utils.xq";

let $svg-width := 1000
let $svg-height := 400

return
<svg version="1.1"
     xmlns:xlink="http://www.w3.org/1999/xlink"
     baseProfile="full" width="{$svg-width}" height="{$svg-height}">     
     <style type="text/css">
        .guide {{ stroke: red; fill: none; fill-opacity: none; }}
        .valley-fold {{ stroke: black; stroke-dasharray: 9, 5; fill:none; }}
        .mountain-fold {{ stroke: black; stroke-dasharray: 9, 5, 3, 5; fill: none; }}
        .cut {{ stroke:black; fill: none; }}
     </style>
     <defs>
     <path id="star" d="M 50,0 V 100 M 0,50 H 100 M 0,0 L 100,100 M 100,0 L 0,100" />
     </defs>
     <g transform="translate(0,150)">
     <path class="cut" d="M 50,0 H 100 M 50,100 H 100 M 50,0 A 50,50 0 1,0 50,100 
                        M 150,0 V 100 M 150,50 H 250 M 250,0 V 100 
                        M 350,0 L 300,100 M 350,0 L 400,100 M 325,50 H 375
                        M 450,0 V 100 M 450,0 H 500 M 450,50 H 500 M 500,0 A 25,25 0 1,1 500,50 M 450,50 L 550,100
                        M 600,0 V 100 H 700
                        M 750,0 V 100 H 850 M 750,0 H 850 M 750,50 H 850
                        M 950,0 A 25,25 0 1,0 950,50 A 25,25 0 1,1 950,100 M 950,0 H 1000 M 900,100 H 950" />
     </g>
     {for $i in (1 to 2) 
     return
     <g transform="{svg-utils:translate(0,($i - 1) * 300)}">
     {
     for $j in (1 to 10)
         return
         <g transform="{svg-utils:translate(($j - 1) * 100)}">
            <use xlink:href="#star" class="cut" />
         </g>
     }
     </g>
     }
</svg>