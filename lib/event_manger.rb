puts "welcome eventmanager"
#lines = File.readlines "../event_attendees.csv"

# =================track the index ==================
# row_index=0
# lines.each do |line|
#   row_index == row_index + 1
#   next if row_index == 0
#   columns = line.split(",")
#   name=columns[2]
#   puts name
# end

# ===========arrary===========

# lines.each_with_index do |line, index|
#   next if index == 0
#   columns = line.split (",")
#   name = columns[2]
#   puts name

# end



# require "csv"
# contents = CSV.open "../event_attendees.csv", headers: true, header_converters: :symbol
# contents.each do |row|
#   name = row[:first_name]
#   zipcode = row[:zipcode]

#   if zipcode.nil?
#     zipcode="00000"
#   elsif zipcode.length < 5
#     zipcode = zipcode.rjust 5, "0"
#   else
#     zipcode= zipcode[0..4]
#   end
#   puts "#{name}  #{zipcode}"
# end



# require "csv"
# def clean_zipcode (zipcode)
#   # if zipcode.nil?
#   #   "0000"
#   # elsif zipcode.length < 5
#   #   zipcode = zipcode.rjust 5, "0"
#   # elsif zipcode.length > 5
#   #   zipcode= zipcode[0..4]
#   # else
#   #   zipcode
#   # end

#   zipcode.to_s.rjust(5,"0")[0..5]
# end 

# contents =CSV.open "../event_attendees.csv", headers: true, header_converters: :symbol
# contents.each do |row|
#   name =  row[:first_name]
#   zipcode = clean_zipcode(row[:zipcode])
#   puts "#{name} #{zipcode}"
# end 

require "csv"
require "sunlight/congress"
require "erb"

Sunlight::Congress.api_key = "3905ffd774d04c8d9310a297da000a4b"
puts "welcome sunlight"

def clean_zipcode (zipcode)

  zipcode.to_s.rjust(5,"0")[0..5]

end 

def legislator_by_zipcode(zipcode)
legislators = Sunlight::Congress::Legislator.by_zipcode(zipcode)
    # legislator_name = legislators.collect do |legislator|
    #   "#{legislator.first_name} #{legislator.last_name}"
    # end
     # legislator_name.join(",")
end

# contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

# contents.each do |row|
#   name = row[:first_name]

#   zipcode = clean_zipcode(row[:zipcode])



# # legislator_names = []
# #   legislators.each do |legislator|

# #     legislator_name = "#{legislator.first_name} #{legislator.last_name}"
# #     legislator_names.push legislator_name
      
# #   end
# lagislators= legislator_by_zipcode(zipcode);

# puts "#{name} #{zipcode} #{lagislators}"
# end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir("output") unless Dir.exists? "output"
  filename = "output/thanks_#{id}.html"
  File.open(filename,'w') do |file|
    file.puts form_letter
  end
end

templete_letter= File.read "form_letter.erb"
erb_templete = ERB.new templete_letter

contents = CSV.open "event_attendees.csv", headers: true, header_converters: :symbol

contents.each do|row|
  id = row[0]
  name = row[:first_name]
  
  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislator_by_zipcode(zipcode)

  # personal_letter = templete_letter.gsub("FIRST_NAME", name)
  # personal_letter.gsub!("LEGISLATORS",legislators)
  # puts personal_letter

  form_letter = erb_templete.result(binding) 
  save_thank_you_letter(id,form_letter)
end

