require 'rspec'
require 'selenium-webdriver'
require_relative '../database'
require_relative '../site'

describe 'Correct worcking table to the site' do
  let(:site) { Site.new }
  let(:value) { [{ 'name' => '', 'count' => '', 'price' => '' }] }
  let(:driver) { Selenium::WebDriver.for :chrome }

  context 'when values are inserted correctly into the table' do
    it 'checks name value in the table' do
      value.first['name'] = 'testname'
      site.add_to_table(value)

      expect(site.load_table.last[0]).to eq('testname')
    end

    it 'checks count value in the table' do
      value.first['count'] = 1234567890
      site.add_to_table(value)

      expect(site.load_table.last[1]).to eq(123456789)
    end

    it 'checks price value in the table' do
      value.first['price'] = 1234567890.98
      site.add_to_table(value)

      expect(site.load_table.last[2]).to eq(1234567890.98)
    end
  end

  context 'when values are inserted' do
    before(:each) do
      driver.get('http://tereshkova.test.kavichki.com/')
      driver.find_element(id: :open).click
    end

    it 'checks text fields name to clear' do
      driver.find_element(id: :name).send_keys ('testname')
      driver.find_element(id: :add).click

      expect(driver.find_element(id: :name).attribute('value')).to be_empty
    end

     it 'checks text fields count to clear' do
      driver.find_element(id: :count).send_keys (123456789)
      driver.find_element(id: :add).click

      expect(driver.find_element(id: :count).attribute('value')).to be_empty
    end

     it 'checks text fields price to clear' do
      driver.find_element(id: :price).send_keys (123456789.98)
      driver.find_element(id: :add).click

      expect(driver.find_element(id: :price).attribute('value')).to be_empty
    end
  end

  context 'when press button "сбросить"' do
    before(:each) do
      driver.get('http://tereshkova.test.kavichki.com/')
      driver.find_element(id: :open).click
    end

    it 'clears name text field' do
      driver.find_element(id: :name).send_keys('testname')

      expect{ driver.find_element(xpath: "//body/a[2]").click }.to change{ driver.find_element(id: :name).attribute('value') }.from('testname').to be_empty
    end

    it 'clears count text field' do
      driver.find_element(id: :count).send_keys(123456789)

      expect{ driver.find_element(xpath: "//body/a[2]").click }.to change{ driver.find_element(id: :count).attribute('value') }.from(123456789).to be_empty
    end

    it 'clears price text field' do
      driver.find_element(id: :price).send_keys(123456789.98)

      expect{ driver.find_element(xpath: "//body/a[2]").click }.to change{ driver.find_element(id: :price).attribute('value') }.from(123456789.98).to be_empty
    end
  end

  context 'when press button "удалить" to row number 2' do
    it 'checks delete row number 2' do
      driver.get('http://tereshkova.test.kavichki.com/')

      row_number_two = driver.find_element(xpath: "//tr[2]").text
      row_number_three = driver.find_element(xpath: "//tr[3]").text

      expect{ driver.find_element(xpath: '//tr[2]/td[4]').click }.to change{ driver.find_element(xpath: "//tr[2]").text }.from(row_number_two).to(row_number_three)
    end
  end
end
