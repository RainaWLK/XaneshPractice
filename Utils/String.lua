-- SOURCE: codea.io/talk/discussion/2118/split-a-string-by-return-newline
function XANESHPRACTICE.split_lines(str)
  local t = {}
  local function helper(line) table.insert(t, line) return "" end
  helper((string.gsub(str,"(.-)\r?\n", helper)))
  return t
end
