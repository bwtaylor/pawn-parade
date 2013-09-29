
Given(/^a file (.*) exists relative to the current working directory with content matching file (.*)$/)  do |cwd_file, reference_file|
  assert(File.readable?(reference_file))
  content = IO.read(reference_file)
  write_file(cwd_file, content)
end