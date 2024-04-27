local utils = {}

function utils.dump_table(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. utils.dump_table(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end
