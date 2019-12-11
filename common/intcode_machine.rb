class IntcodeMachine
  # attr_reader :output, :program
  attr_accessor :debug

  def initialize(program, *input, debug: false)
    @program = program.clone + [0]*1000
    @input = input.clone
    @debug = debug
    @output = []
    @failed = false
    @idx = 0
    @rel = 0
  end

  def run(*input)
    @input += input if input.any?
    while !halted?
      case intcode
      when 1 # add
        write 3, ptr(1) + ptr(2)
        @idx += 4
      when 2 # multiply
        write 3, ptr(1) * ptr(2)
        @idx += 4
      when 3 # read
        write 1, @input.shift
        @idx += 2
      when 4 # write
        @output << ptr(1)
        @idx += 2
        return @output.last if !debug
      when 5 # jump if true
        @idx = ptr(1) != 0 ? ptr(2) : @idx + 3
      when 6 # jump if false
        @idx = ptr(1).zero? ? ptr(2) : @idx + 3
      when 7 # less than
        write 3, (ptr(1) < ptr(2) ? 1 : 0)
        @idx += 4
      when 8 # equals
        write 3, (ptr(1) == ptr(2) ? 1 : 0)
        @idx += 4
      when 9 # adjust relative base
        @rel += ptr(1)
        @idx += 2
      else
        puts "Program failed on opcode #{ intcode }"
        @failed = true
        return nil
      end
    end
    return @output.inspect if debug
  end

  def last_output
    @output.last
  end

  def halted?
    intcode == 99 || failed?
  end

  def failed?
    @failed
  end

  private

  # Get value of parameter.
  # If parameter mode is 0 or 2 then the parameter
  # is a memory address (aka it's a pointer).
  # Else return the literal value.
  def addr(pos)
    case @program[@idx].div(10**(pos+1)).modulo(10)
    when 0
      @program[@idx + pos]
    when 1
      @idx + pos
    when 2
      @program[@idx + pos] + @rel
    end
  end

  def ptr(pos)
    @program[addr(pos)] || 0
  end

  def write(pos, val)
    @program[addr(pos)] = val
  end

  def intcode
    @program[@idx] % 100
  end
end
