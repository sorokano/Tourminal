<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Page.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Новости
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
	    $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageNewsId %>);
        });
    </script>
    <span class="mainTitle">
        <h1><%= ViewData["PageTitle"] %></h1>
    </span>
    <p>
        <%= ViewData["PageContent"] %>
    </p>
	<% if (ElcondorBiz.BizNews.GetNewsList().Count > 0) { %>
		<div class="travel_notes relover">
			<div class="wrapper">
				<div class="travel_notes_h relover">
					<h2>Новости</h2>
				</div>
				<div class="g-block g-dotted-v g-clearfix">
					<div class="b-news-column b-news-column-right">
						<div class="g-wrap g-clearfix">
							<%= Elcondor.UI.Utilities.GridNewsHelper.GetNewsListHTML() %>
						</div>
					</div>
				</div>
			</div>
		</div>
	<% } %>

</asp:Content>
