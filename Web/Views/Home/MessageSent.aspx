<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Article.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - Заявка отправлена
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        $(document).ready(function () {
            $(".right_menu_list li").each(function () {
                $(this).removeClass("selected");
            });
        });
    </script>
    <span class="mainTitle">
        <h1>Заявка отправлена</h1>
    </span>
    <p>
        Спасибо, что обратились к вам! Ваша заявка была отправлена нашему сотруднику. Мы ответим Вам в ближайшее время.
    </p>

</asp:Content>
