local _PACKAGE = string.gsub(...,"%.","/") or ""
if string.len(_PACKAGE) > 0 then _PACKAGE = _PACKAGE .. "/" end

require (_PACKAGE .. '.libs.primitives')
return require (_PACKAGE .. '.libs.animations')