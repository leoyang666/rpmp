require 'stringio'
class Sys::ConsoleController < Sys::AdminController

  def index
  end

  def run
    session[:script] = params[:script]
    stdout_orig = $stdout
    $stdout = StringIO.new
    begin
      result_eval = eval params[:script], binding
      $stdout.rewind
      result = %Q{<div class="stdout">#{escape $stdout.read}</div><div class="return">#{escape result_eval.inspect}</div>}
    rescue Exception => e
      result = e.to_s
    end
    $stdout = stdout_orig
    render :text => result.gsub("\n", "<br />\n")
  end

  private

  def escape(content)
    view_context.escape_once content
  end

  def check_sysrole
    require_root
  end
end
