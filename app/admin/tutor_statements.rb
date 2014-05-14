ActiveAdmin.register TutorStatement do
  menu parent: 'Teachers', priority: 1, label: 'Statements'
  actions :index, :show

  config.batch_actions = true

  scope :all, default: true
  scope 'Old Unfinalized' do |statements|
    statements.past.unfinalized
  end
  scope 'Old Unpublished' do |statements|
    statements.past.unpublished
  end
  scope :previous_month
  scope :current_month

  filter :month, as: :select, collection: Proc.new {(1..12).each_with_object({}) {|i,h| h[Date::MONTHNAMES[i]] = i}}
  filter :year, as: :select, collection: Proc.new {(2013..Time.now.year)}

  index do
    selectable_column
    column 'Teacher', sortable: 'teachers.name' do |statement|
      statement.teacher
    end
    column :month_name, sortable: :month
    column :year
    # column 'Lessons Count', sortable: :lesson_count do |statement|
    #   statement.reservations.where(reservation_type: [:comped, :paid, :package]).count
    # end
    column :lesson_count, sortable: :lesson_count
    column 'Reservations Gross Payable' do |statement|
      number_to_currency statement.reservations_gross_payable
    end
    column 'Commission' do |statement|
      "#{statement.commission}%"
    end
    column 'Commission Value' do |statement|
      number_to_currency statement.commission_value
      #number_to_currency(statement.reservations_gross_payable - statement.reservations_net_payable)
    end
    column 'Miscellaneous Payable' do |statement|
      number_to_currency statement.miscellaneous_payable
    end
    column 'Total Payable' do |statement|
      number_to_currency statement.total_payable
    end
    column :actions do |statement|
      links = []
      links << link_to('Publish', publish_admin_tutor_statement_path(statement)) if (statement.finalized? && !statement.published)
      links << link_to('View', show_pdf_admin_tutor_statement_path(statement)) if statement.finalized?
      links << link_to('Edit', admin_tutor_statement_path(statement)) unless statement.finalized?
      links << link_to('Preview', show_pdf_admin_tutor_statement_path(statement)) unless statement.finalized?
      links.join(' ').html_safe
    end
  end

  show do |statement|
    attributes_table do
      row :id
      row :teacher
      row :year
      row :month_name
      row :finalized do
        statement.finalized?
      end
      row :published do
        !!statement.published
      end
      row "Reservations Gross Payable" do
        number_to_currency statement.reservations_gross_payable
      end
      row :commission do
        links = []
        TutorStatement::COMMISSIONS.each do |commission|
          if statement.commission == commission
            links << "#{commission}%"
          else
            links << link_to("#{commission}%", change_commission_admin_tutor_statement_path(statement, commission: commission))
          end
        end
        links.join(' | ').html_safe
      end
      row "Commission Value" do
        number_to_currency statement.commission_value
      end
      row "Reservations Net Payable" do
        number_to_currency statement.reservations_net_payable
      end
      row :miscellaneous_payble do
        number_to_currency statement.miscellaneous_payable
      end
      row 'Total Payable' do
        number_to_currency statement.total_payable
      end
      row :created_at
      row :updated_at
    end

    panel 'Reservation Line Items' do
      table_for statement.reservations.comped_or_paid do
        column :starts_at do |reservation|
          time = reservation.starts_at.in_time_zone(TutorStatement::STATEMENT_TIME_ZONE)
          time.strftime('%B %d at %I:%M %P %Z')
        end
        column :student
        column :gross_payable_value do |reservation|
          number_to_currency reservation.gross_payable_value
        end
        column :reservation_type
        column :actions do |reservation|
          links = []
          links << link_to('View', admin_reservation_path(reservation))
          links.join(' ').html_safe
        end
      end
    end

    panel "Miscellaneous Line Items".html_safe do
      div do
        link_to 'CREATE', new_admin_tutor_statement_miscellaneous_line_item_path(tutor_statement_id: statement.id)
      end
      table_for statement.tutor_statement_miscellaneous_line_items do
        column :description
        column :amount do |item|
          number_to_currency item.amount
        end
        column :actions do |item|
          links = []
          links << link_to('Delete', admin_tutor_statement_miscellaneous_line_item_path(item), method: :delete)
          links.join(' ').html_safe
        end
      end
    end

    active_admin_comments
  end

  batch_action :finalize do |selection|
    TutorStatement.find(selection).each do |statement|
      statement.delay.finalize
    end
    redirect_to admin_tutor_statements_path
  end

  batch_action :publish do |selection|
    TutorStatement.find(selection).each do |statement|
      statement.publish
    end
    redirect_to admin_tutor_statements_path
  end

  member_action :show_pdf, method: :get do
    @tutor_statement = TutorStatement.find(params[:id])
    send_data(*TutorStatementPdf.new(@tutor_statement).send_data_params)
  end

  member_action :finalize, method: :post do
    @tutor_statement = TutorStatement.find(params[:id])
    if @tutor_statement.finalize
      notice = "#{@tutor_statement.teacher.name}'s statement for #{@tutor_statement.month_name} #{@tutor_statement.year} finalized."
      redirect_to admin_tutor_statements_path, notice: notice
    else
      redirect_to admin_tutor_statement_path(@tutor_statement), notice: 'Finalization failed'
    end
  end

  member_action :publish, method: :get do
    @tutor_statement = TutorStatement.find(params[:id])
    if @tutor_statement.publish
      notice = "#{@tutor_statement.teacher.name}'s statement for #{@tutor_statement.month_name} #{@tutor_statement.year} published."
      redirect_to admin_tutor_statements_path, notice: notice
    else
      redirect_to admin_tutor_statements_path, notice: 'Publish failed'
    end
  end

  member_action :change_commission, method: :get do
    @tutor_statement = TutorStatement.find(params[:id])
    @tutor_statement.commission = params[:commission]
    if @tutor_statement.save
      redirect_to admin_tutor_statement_path(@tutor_statement), notice: 'Commission changed'
    else
      redirect_to admin_tutor_statement_path(@tutor_statement), notice: 'Commission could not be changed'
    end
  end

  collection_action :generate_previous, method: :get do
    TutorStatement.generate_all_for_previous_week
    redirect_to admin_tutor_statements_path, notice: 'Previous week generated'
  end

  collection_action :generate_current, method: :get do
    TutorStatement.generate_all_for_current_month
    redirect_to admin_tutor_statements_path, notice: 'Current month generated'
  end

  action_item only: :show do
    link_to "Finalize Statement", finalize_admin_tutor_statement_path(tutor_statement), method: :post unless tutor_statement.finalized?
  end

  action_item only: :show do
    link_to "Preview Statement", show_pdf_admin_tutor_statement_pathatement_path(tutor_statement), method: :get unless tutor_statement.finalized?
  end

  action_item only: :index do
    link_to "Generate Previous Week's Statements", generate_previous_admin_tutor_statements_path
  end

  action_item only: :index do
    # link_to "Generate Current Month's Statements", generate_current_admin_tutor_statements_path
  end


  controller do
    def show
      @tutor_statement = TutorStatement.find(params[:id])
      if @tutor_statement.finalized?
        redirect_to show_pdf_admin_tutor_statement_path(@tutor_statement)
      else
        super
      end
    end

    def scoped_collection
      end_of_association_chain.includes(:teacher)
    end

    def apply_pagination(chain)
      chain = super unless formats.include?(:json) || formats.include?(:csv)
      chain
    end
  end

  csv do
    column "Name" do |statement|
      statement.teacher.name
    end
    column "Statement Date" do |statement|
      "#{statement.month_name} #{statement.year}"
    end
    column "Payable" do |statement|
      number_to_currency statement.total_payable
    end
    column 'Reservations Gross Payable' do |statement|
      number_to_currency statement.reservations_gross_payable
    end
    column 'Commission' do |statement|
      "#{statement.commission}%"
    end
    column 'Commission Value' do |statement|
      number_to_currency statement.commission_value
    end
  end
end
