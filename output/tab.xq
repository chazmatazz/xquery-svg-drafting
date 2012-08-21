(: XQuery main module :)
declare default element namespace "http://www.w3.org/2000/svg";

declare namespace xlink = "http://www.w3.org/1999/xlink";

let $tab-height := 50
let $tab-width := 100

let $num-tabs := 10

let $svg-width := $tab-width * $num-tabs
let $svg-height := $tab-height

return
<svg xmlns="http://www.w3.org/2000/svg"
    version="1.1" baseProfile="full" width="{$svg-width}" height="{$svg-height}">
    <style type="text/css">
        .tab {{ stroke: black; fill:none; }}
    </style>
    <defs>
    <path id="tab" class="tab" d="M 0,50
                                    q 35,0 25,-25 
                                    -10,-25 25,-25 
                                    35,0 25,25 
                                    -10,25 25,25" />
    </defs>
    { for $i in (1 to $num-tabs)
        let $transform := concat("translate(", ($i - 1) * $tab-width, ",0)")
        return
        <use xlink:href="#tab" transform="{$transform}" />
    }
</svg>