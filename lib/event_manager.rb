require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
    zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
    civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
    civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'
  
    begin
        civic_info.representative_info_by_address(
            address: zip,
            levels: 'country',
            roles: ['legislatorUpperBody', 'legislatorLowerBody']
            ).officials
    rescue
      'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
    end
  end

def save_thank_you_letter(id, form_letter)
    Dir.mkdir('output') unless Dir.exist?('output')

    filename = "output/thanks_#{id}.html"

    File.open(filename, 'w') do |file|
        file.puts form_letter
    end
end

def readable_phone(num)
    num.gsub!(/\D/, '') if num.is_a?(String)
    num.to_i
end

def phone_number_length(phone_number)
    phone_number.digits.length
end

def first_digit(phone_number)
    first = phone_number.to_s[0].to_i
end

def remove_first_digit(phone_number)
    valid_phone_number = phone_number.to_s[1..9]
end

def normalize_phone_number(phone_number)
    phone_number = readable_phone(phone_number)
    length = phone_number_length(phone_number)
    if length == 10
        phone_number
    elsif length == 11 && first_digit(phone_number) == 1
        phone_number = remove_first_digit(phone_number)
        phone_number
    else
        'Invalid phone number'
    end
end

puts 'EventManager initialized!'

contents = CSV.open('event_attendees.csv', 
    headers: true,
    header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
    id = row[0]
    # name = row[:first_name]

    # zipcode = clean_zipcode(row[:zipcode])

    # legislators = legislators_by_zipcode(zipcode)

    # form_letter = erb_template.result(binding)

    # save_thank_you_letter(id, form_letter)
    phone_number = row[:homephone]
    
    puts "#{id}: #{normalize_phone_number(phone_number)}"
    # if phone < 10 bad
    # if phone == 10 good
    # if phone is 11 and 0 is 1, trim the 1 and its good
    # if phone is 11 and 0 isn't 1 bad
    # if phone > 11 bad
    
    


end