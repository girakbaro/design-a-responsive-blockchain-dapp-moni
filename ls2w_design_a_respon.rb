# ls2w_design_a_respon.rb

# Import necessary gems
require 'sinatra'
require 'slim'
require 'sass'
require ' ThinReports'

# Define the class for the dApp monitor
class dAppMonitor
  def self.fetch_data
    # Fetch data from blockchain API
    # For demonstration purposes, we'll use a sample dataset
    [
      { id: 1, name: 'dApp 1', blocks: 100, txs: 500 },
      { id: 2, name: 'dApp 2', blocks: 200, txs: 800 },
      { id: 3, name: 'dApp 3', blocks: 300, txs: 1200 }
    ]
  end

  def self.generate_report(data)
    # Generate a report using ThinReports
    report = ThinReports::Report.new
    report.start_new_page

    data.each do |dapp|
      report.page.item(:text).set({
        content: "#{dapp[:name]} (#{dapp[:id]})",
        size: 18,
        style: :bold
      })

      report.page.item(:text).set({
        content: "Blocks: #{dapp[:blocks]}",
        size: 14
      })

      report.page.item(:text).set({
        content: "Transactions: #{dapp[:txs]}",
        size: 14
      })

      report.page.line(10, 10, 190, 10) # Add a horizontal line
    end

    report.generate(:pdf, 'report.pdf')
  end
end

# Define the Sinatra routes
class LS2WDesignARespon < Sinatra::Base
  get '/' do
    slim :index
  end

  get '/report' do
    data = dAppMonitor.fetch_data
    dAppMonitor.generate_report(data)
    send_file 'report.pdf', type: 'application/pdf', disposition: 'attachment'
  end

  get '/data' do
    data = dAppMonitor.fetch_data
    content_type :json
    data.to_json
  end
end

# Run the Sinatra app
LS2WDesignARespon.run!