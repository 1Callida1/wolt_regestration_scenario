# frozen_string_literal: true

require 'faraday'
require 'faker'
require 'capybara'
require 'selenium-webdriver'
require 'pry'
require 'dotenv'

# top comment
class Helper # rubocop:disable Metrics/ClassLength
  def watch_video_fake_activity
    @session.first("a[aria-label*='Home']").click
    sleep(rand(2..4))
    puts '[log] Return to the home page'

    @session.first("button[class*='PlayButton-module']").click
    sleep(rand(32..34))
    puts '[log] Watch video'

    @session.first("a[aria-label*='Home']").click
    sleep(rand(2..4))
    puts '[log] Return to the home page'
  end

  def address_fake_activity # rubocop:disable Metrics/MethodLength
    @session.first("a[data-test-id*='UserStatusDropdown']").click
    sleep(rand(2..4))
    puts '[log] User drop down menu open'

    @session.first("li[class*='UserMenu-module'] a[href*='/en/me']").click
    sleep(rand(2..4))
    puts '[log] Open profile menu'

    @session.first("li[class] a[href*='/en/me/addresses']").click
    sleep(rand(2..4))
    puts '[log] Open settings'

    @session.first("button[class*='Button-module']").click
    sleep(rand(2..4))
    puts '[log] Open menu add address'

    input_address_add = @session.first("input[id='address']")
    input_address_add.click
    input_address_add.send_keys Faker::Address.city
    sleep(rand(2..4))
    puts '[log] Add address'

    session.all("div[class] label[class*='location-module']").sample.click
    sleep(rand(2..4))
    puts '[log] Select location'

    @session.first("button[class*='UserAddressEditor']").click
    sleep(rand(2..4))
    puts '[log] Add new address'

    @session.first("a[aria-label*='Home']").click
    sleep(rand(2..4))
    puts '[log] Return to the home page'
  end

  def settings_edit_fake_activity # rubocop:disable Metrics/MethodLength
    @session.first("a[data-test-id*='UserStatusDropdown']").click
    sleep(rand(2..4))
    puts '[log] User drop down menu open'

    @session.first("li[class*='UserMenu-module'] a[href*='/en/me']").click
    sleep(rand(2..4))
    puts '[log] Open profile menu'

    @session.first("li[class] a[href*='/en/me/settings']").click
    sleep(rand(2..4))
    puts '[log] Open settings'

    session.all("div[class*='select-container'] div[class] select[class] option[value]").sample.click
    sleep(rand(2..4))
    puts '[log] Switch city'

    @session.first("a[aria-label*='Home']").click
    sleep(rand(2..4))
    puts '[log] Return to the home page'
  end

  def options_check_fake_activity # rubocop:disable Metrics/MethodLength
    @session.first("a[data-test-id*='UserStatusDropdown']").click
    sleep(rand(2..4))
    puts '[log] User drop down menu open'

    @session.first("li[class*='UserMenu-module'] a[href*='/en/me']").click
    sleep(rand(2..4))
    puts '[log] Open profile menu'

    button = @session.first('ul').all('li').sample
    button.first('a').click
    sleep(rand(2..4))
    puts '[log] Random button click'

    @session.first("a[aria-label*='Home']").click
    sleep(rand(2..4))
    puts '[log] Return to the home page'
  end

  def serach_fake_activity # rubocop:disable Metrics/MethodLength
    @session.first("button[class*='DeliveryLocationButton']").click
    sleep(rand(2..4))
    puts '[log] Change location botton click'

    @session.first("button[class*='DiscoveryFooter']").click
    sleep(rand(2..4))
    puts '[log] Switch city button click'

    session.all("div[class*='CityList-module'] a[href]").sample.click
    sleep(rand(2..4))

    serach_input = @session.first("input[id*='SearchInput']").click
    sleep(rand(2..4))

    serach_input.send_keys 'kfc'
    sleep(rand(2..4))
    puts '[log] Input kfc to the serach'

    @session.first("a[href*='kfc-inshaatchilar']").click
    sleep(rand(2..4))
    puts '[log] Click to the serach button'

    @session.first('p', text: 'Combo Menu №1 😍').click
    sleep(rand(2..4))
    puts '[log] Select first element'

    @session.first("button[data-test-id*='AddToOrderButton']").click
    sleep(rand(2..4))
    puts '[log] Add to order new item'

    @session.first("button[class*='orderButton']").click
    sleep(rand(2..4))
    puts '[log] Open card'

    @session.first("a[aria-label*='Home']").click
    sleep(rand(2..4))
    puts '[log] Return to the home page'
  end

  def fake_activity # rubocop:disable Metrics/MethodLength
    helper = Helper.new
    request_count = rand(2..5)
    while request_count != 0
      case request_count + rand(0..1) - rand(0..1)
      when 1
        helper.serach_fake_activity
        puts '[log] Activity start'
      when 2
        helper.options_check_fake_activity
        puts '[log] Activity start'
      when 3
        helper.settings_edit_fake_activity
        puts '[log] Activity start'
      when 4
        helper.address_fake_activity
        puts '[log] Activity start'
      when 5
        helper.watch_video_fake_activity
        puts '[log] Activity start'
      else
        puts '[log] Activity not start'
      end
      request_count -= 1
    end
  end

  def phone_number_get # rubocop:disable Metrics/MethodLength
    Dotenv.load
    response = Faraday.get("https://sms-activate.ru/stubs/handler_api.php?api_key=#{ENV['API_KEY']}&action=getNumber&service=ot&forward=0&ref=$ref&country=#{ENV['COUNTRY']}")

    puts '[log] Try to get phone number'
    puts @api_key
    case response.body
    when 'NO_NUMBERS'
      raise '[Log] No phone_numbers'
    when 'NO_BALANCE'
      raise '[Log] Not enough balance'
    when 'WRONG_SERVICE'
      raise '[Log] Service dosn`t exist'
    when 'ERROR_SQL'
      raise '[Log] Error with sql'
    when 'BAD_KEY'
      raise '[Log] Uncorrect api-key'
    when response.body.split(':').first
      raise "[Log] Account was blocked on #{response.body.split(':').last}"
    else
      puts "[Log] Phone number is #{response.body.split(':').last.to_i}"
      response.body.split('R:').last
    end
  end

  def get_phone_activate(id_number) # rubocop:disable Metrics/MethodLength
    Dotenv.load
    response = Faraday.get("https://sms-activate.ru/stubs/handler_api.php?api_key=#{ENV['API_KEY']}&action=setStatus&status=1&id=#{id_number}")
    puts '[log] Try to get phone activate'

    case response.body
    when 'NO_ACTIVATION'
      raise '[Error] Id ready dosnt exist'
    when 'BAD_SERVICE'
      raise '[Error] Service dosn`t exist'
    when 'ERROR_SQL'
      raise '[Error] Error with sql'
    when 'BAD_KEY'
      raise '[Error] Uncorrect api-key'
    when 'ACCESS_READY'
      puts '[Log] Phone number is ready'
    end
  end

  def get_sms(id_number) # rubocop:disable Metrics/MethodLength
    Dotenv.load
    attempt = 0
    while attempt < 4
      response = Faraday.get("https://sms-activate.ru/stubs/handler_api.php?api_key=#{ENV['API_KEY']}&action=getFullSms&id=#{id_number}")
      puts '[log] try to get sms'

      case response.body
      when 'NO_ACTIVATION'
        raise '[Error] Id ready dosnt exist'
      when 'ERROR_SQL'
        raise '[Error] Error with sql'
      when 'BAD_KEY'
        raise '[Error] Uncorrect api-key'
      when 'STATUS_WAIT_CODE'
        puts '[Log] Waiting the sms'
        attempt += 1
        sleep(30)
        raise '8===>' if attempt == 4
      else
        puts "[Log] Sms is arrived, activate code is #{response.body.split(' ').last}"
        return response.body.split(' ').last
      end
    end
  end

  def account_create(phone_number_from_response)
    {
      phone: phone_number_from_response,
      details: {
        firstname: Faker::Name.first_name,
        lastname: Faker::Name.last_name
      }
    }
  end

  def registration(account, email, id_number) # rubocop:disable Metrics/MethodLength
    if @session.has_css?("div[class*='ButtonsContainer'] button[data-localization-key*='accept-button']")
      @session.first("div[class*='ButtonsContainer'] button[data-localization-key*='accept-button']").click
    end
    sleep(rand(2..4))
    puts '[log] Button coockie accept click'

    @session.all("button[class*='UserStatus']").last.click
    sleep(rand(2..4))
    puts '[log] Button regist click'

    email_input = @session.first('input[type*=email]')
    sleep(rand(2..4))

    email_input.click
    sleep(rand(2..4))

    puts 'Email input box click'

    email_input.send_keys email
    sleep(rand(2..4))

    puts "[log] Email #{email} input"

    @session.first("div[class*='StepMethodSelect'] button[role*='button']").click
    sleep(rand(2..4))
    sleep(60)

    puts '[log] Button email accept click'

    first_name_input = @session.first("input[name*='firstName']")
    first_name_input.send_keys account[:details][:firstname]
    sleep(rand(2..4))

    puts "[log] Input first name #{account[:details][:firstname]}"

    last_name_input = @session.first("input[name*='lastName']")
    last_name_input.send_keys account[:details][:lastname]
    sleep(rand(2..4))

    puts "[log] Input last name #{account[:details][:lastname]}"

    @session.first("div[class*='Select-module'] option[value*='UA']").click
    sleep(rand(2..4))

    puts '[log] Country select Ukraine'

    phone_number_input = @session.first("input[id*='mobileNumber']")
    phone_number_input.send_keys account[:phone]
    sleep(rand(2..4))

    puts "[log] Input phone number #{account[:phone]}"

    @session.first("p[class*='Checkbox-module']").click
    sleep(rand(2..4))

    puts '[log] Accept checkbox'

    @session.first("button[class*='Signup-module']").click
    sleep(rand(2..4))

    puts '[log] Button registration click'

    code = get_sms(id_number)
    code.chars
    code_input_first = @session.first("input[id*='0']").click
    code_input_first.send_keys code[0]
    sleep(rand(2..4))

    puts "[log] Input first character of code #{code[0]}"

    code_input_second = @session.first("input[id*='1']").click
    code_input_second.send_keys code[1]
    sleep(rand(2..4))

    puts "[log] Input second character of code #{code[1]}"

    code_input_third = @session.first("input[id*='2']").click
    code_input_third.send_keys code[2]
    sleep(rand(2..4))

    puts "[log] Input third character of code #{code[2]}"

    code_input_fourth = @session.first("input[id*='3']").click
    code_input_fourth.send_keys code[3]
    sleep(rand(2..4))

    puts "[log] Input fourth character of code #{code[3]}"

    code_input_fifth = @session.first("input[id*='4']").click
    code_input_fifth.send_keys code[4]
    sleep(rand(2..4))

    puts "[log] Input fifth character of code #{code[4]}"

    @session.first("div[class*='StepVerify'] button[class*='Button-module']").click
  end

  def generate_session # rubocop:disable Metrics/MethodLength
    chrome_args = [
      'ignore-ssl-errors=yes',
      'ignore-certificate-errors',
      '--no-sandbox',
      '--disable-dev-shm-usage',
      '--blink-settings=imagesEnabled=true',
      '--disable-save-password-bubble',
      '--disable-notifications',
      '--start-maximized',
      '--disable-blink-features=AutomationControlled'
    ]

    chrome_args << '--user-agent=Mozilla/5.0 (X11; Linux x86_64)" \
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.77 Safari/537.36'
    chrome_args << '--headless' if ENV['HEADLESS'] == 'true'

    Capybara.register_driver :driver do |app|
      Capybara::Selenium::Driver.new(app,
                                     browser: :chrome,
                                     http_client: Selenium::WebDriver::Remote::Http::Default.new(
                                       read_timeout: 240,
                                       open_timeout: 240
                                     ),
                                     desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(
                                       'goog:chromeOptions': {
                                         excludeSwitches: ['enable-automation'],
                                         useAutomationExtension: false,
                                         w3c: false,
                                         args: chrome_args
                                       },
                                       enableVNC: true,
                                       screenResolution: '1920x1080x24',
                                       browserName: 'chrome',
                                       sessionTimeout: '5m'
                                     ))
    end

    Capybara.javascript_driver = :chrome
    Capybara.default_max_wait_time = 10
    @session = Capybara::Session.new(:driver)
  end
end
