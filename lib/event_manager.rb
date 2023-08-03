require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'
require 'time'

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

def readable_date(date)
    readable_date = date.split(" ")
    only_date = readable_date[0].split("/")
    new_year = only_date.last.prepend("20")
    readable_date[0] = only_date.join("/")
    readable_date.join(" ")
end

def peak_registration_hours(hours)
    hours.max_by { |k,v| v }
end


puts 'EventManager initialized!'

contents = CSV.open('event_attendees.csv', 
    headers: true,
    header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

# initialize a hash to find the highest hour registered
hours_applied = Hash.new(0)
contents.each do |row|
    # id = row[0]
    # name = row[:first_name]

    # zipcode = clean_zipcode(row[:zipcode])

    # legislators = legislators_by_zipcode(zipcode)

    # form_letter = erb_template.result(binding)

    # save_thank_you_letter(id, form_letter)

    # phone_number = row[:homephone]
    # puts "#{id}: #{normalize_phone_number(phone_number)}"

    # find the regdate and time to show the peak hours that people reg
    # find the hours
    # keep tally in a hash of the times
    # show times
    date = row[:regdate]

    p time = Time.strptime(readable_date(date), "%m/%d/%Y %k:%M")
    p time.strftime("%Y") 

    # add hour to hash to find common hour
    hours_applied[time.strftime("%k")] += 1



    # find the regdate that most people reg
    

end
hours_applied
puts peak_registration_hours(hours_applied)