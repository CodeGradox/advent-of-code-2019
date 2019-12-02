input = $<.read.split(",").map(&:to_i)

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

# 3224742
puts "Part 1"
puts real_intcode_computer(input, 12, 2)

(0..99).each do |noun|
  (0..99).each do |verb|
    ret = real_intcode_computer(input, noun, verb)
    next if ret.nil?
    if ret == 19690720
      # 7960
      puts "Part 2"
      puts 100 * noun + verb
      return
    end
  end
end
