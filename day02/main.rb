program = File.open("input").read.split(",").map(&:to_i)

# program = [1,9,10,3,2,3,11,0,99,30,40,50]
# program = [1,1,1,4,99,5,6,0,99]

ADD = 1
MUL = 2
HALT = 99

def apply_intcode(program, idx, &opt)
  a, b, c = program[idx + 1, idx + 3]
  program[c] = opt.call(program[a], program[b])
end

def real_intcode_computer(program, noun, verb)
  program = program.clone
  program[1] = noun
  program[2] = verb
  idx = 0
  loop do
    case program[idx]
    when ADD
      apply_intcode(program, idx, &:+)
    when MUL
      apply_intcode(program, idx, &:*)
    when HALT
      return program[0]
    else
      return nil
    end
    idx += 4
  end
end

puts "Part 1"
puts real_intcode_computer(program, 12, 2)

(0..99).each do |noun|
  (0..99).each do |verb|
    ret = real_intcode_computer(program, noun, verb)
    next if ret.nil?
    if ret == 19690720
      puts "Part 2"
      puts 100 * noun + verb
      return
    end
  end
end
