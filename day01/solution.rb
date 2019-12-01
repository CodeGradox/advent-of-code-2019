input = File.open("input.txt").map(&:to_i)
# input = [100756]

def calculate_fuel mass
  mass.div(3) - 2
end

def recursive_fuel fuel, sum=0
  return sum if fuel <= 0
  recursive_fuel(calculate_fuel(fuel), sum + fuel)
end

# Part 1
# Answer 3365459
list = input.map do |mass|
  calculate_fuel mass
end
puts "Part 1: #{ list.sum }"

# Part 2
# Answer 5045301
final_fuel_sum = list.sum do |fuel|
  recursive_fuel fuel
end

puts "Part 2: #{ final_fuel_sum }"
