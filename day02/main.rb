program = File.open("input").read.split(",").map(&:to_i)

# program = [1,9,10,3,2,3,11,0,99,30,40,50]
# program = [1,1,1,4,99,5,6,0,99]

# Part 1
def real_intcode_computer(program, noun, verb)
  program[1] = noun
  program[2] = verb
  idx = 0
  while program[idx] != 99
    if program[idx] == 1
      a, b, c = program[idx + 1, idx + 3]
      program[c] = program[a] + program[b]
    elsif program[idx] == 2
      a, b, c = program[idx + 1, idx + 3]
      program[c] = program[a] * program[b]
    else
      return nil
    end
    idx += 4
  end
  return program[0]
end

puts "Part 1"
puts real_intcode_computer(program.clone, 12, 2)

(0..99).each do |noun|
  (0..99).each do |verb|
    ret = real_intcode_computer(program.clone, noun, verb)
    next if ret.nil?
    if ret == 19690720
      puts "Part 2"
      puts 100 * noun + verb
      return
    end
  end
end
