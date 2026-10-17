Locales = {}
function _U(key, ...)
    local locale=Locales[Config.Locale] or Locales.en or {}
    local text=locale[key] or (Locales.en or {})[key] or tostring(key)
    return string.format(text,...)
end
