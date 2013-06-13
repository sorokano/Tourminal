<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Article.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Турминал - туристическая компания: Заметки туриста: <%=ViewData["CountryName"] %>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        var word_list = [
            <%= Elcondor.UI.Utilities.TagCloudGenerator.GetRandomTagCloud(int.Parse(Session["CountryId"].ToString())) %>
        ];
        google.load('search', '1', { language: 'ru', style: google.loader.themes.GREENSKY });

        $(document).ready(function () {
            selectTopMenuItem(<%= Elcondor.UI.Utilities.Constants.PageArticlesId %>);
            var id = $.query.get("id");
            if (id != '' && id != '-1') {
                $("#countryname").hide();
                //$("#chooseregion").show();      
                $("#chooseregion").hide();              
                var paramDistr = "countryId=" + $.query.get("id");
                $.getJSON('http://tourminal.ru/ElcondorWCF.svc/GetDistrictListWithArticlesByCountryIdJS' + "?method=?&" + paramDistr, function (response) {
                    var result = '<option value="-1">-- Все регионы страны --</option>';
                    var items = eval('(' + response + ')');
                    for (var i = 0; i < items.length; i++) {
                        result += '<option value="' + items[i].Id + '">' + (items[i].Name) + '</option>';
                    }
                    $("select#" + 'ddlDistrict').html(result);
                    if ($.query.get("regionid") != '0' && $.query.get("regionid") != '' && $.query.get("regionid") != '-1') {
                        $("#ddlDistrict").val($.query.get("regionid"));
                    }
                });
                //populateComboboxNameId('ddlCountryArticle', 'http://tourminal.ru/ElcondorWCF.svc/GetCountryListJS', true);
                $("select#ddlCountryArticle").val(id);
            } else {
                $("#countryname").hide();
                $("#chooseregion").hide();                
            }
            $("#ddlCountryArticle").change(function (e) {
                if ($(this).val() != -1) {
                    document.location = 'CountryArticles?id=' + $(this).val();
                } else {
                    document.location = 'CountryArticles';
                }
            });
//            $("#ddlDistrict").change(function () {
//                var newQuery = $.query.set("regionid", $('option:selected', this).val()).toString();
//                document.location = ((document.location.toString()).split('?'))[0] + newQuery;
//            });
            $("#search").blur(function () {
	            if ($(this).val() == "") {
	                $(this).val("Поиск...");
	                $("#resultbox").css("display", "none");
	            }
	        });
	        $("#search").focus(function () {
	            if ($(this).val() == "Найти...") {
	                $(this).val("Найдено: 0 результатов.");
	            }
	        });
	        $("#search").keyup(function (event) {
                if (event.keyCode == '13') {
	                $("#main.content").html('<div id="resultbox" style="display:none;"><div class="googleheader"></div><div id="googlesearch"></div></div>');
	                $(".googleheader").html('<img src="images/loading.gif" width="16" height="16" style="margin-right:8px; vertical-align:-15%;" />Загружаем результаты с Google...');
	                $("#resultbox").css("display", "");
	                var customSearchControl = new google.search.CustomSearchControl('006469277264750591702:-4olszh1ihw');
	                customSearchControl.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
	                var options = new google.search.DrawOptions();
	                options.setSearchFormRoot('search');
	                customSearchControl.draw('googlesearch', options);
	                customSearchControl.execute(document.getElementById("search").value);
	                if ($(this).val() == "") {
	                    $("#resultbox").slideUp(300, function () {
	                    });
	                }
	            }
	        });
            $("#wordcloud").jQCloud(word_list);
            $('img').live('contextmenu', function (e) {
                return false;
            });
        });
    </script>
    <%--<div id="breadcrumb">
        <a href="http://tourminal.ru">Карта</a> <%if (ViewData["CountryName"] != null) { %><img src="../../Content/Images/greenarrow.png"/> <a href="../../CountryAbout?id=<%= ViewData["CountryId"]%>"> <%=ViewData["CountryName"] %></a><% } %> > Заметки туриста
    </div>--%>
    <span class="topTitle">
        <h1>
            Заметки путешественника<span id="countryname">: <%=ViewData["CountryName"] %></span>
            <% if (ViewData["CountryId"] != null) 
                   if (ElcondorBiz.BizCountry.HasCountryFlag(int.Parse(ViewData["CountryId"].ToString()))) { %> 
                <img src="../../Content/UserImages/flag_<%=ViewData["CountryId"] %>.jpg" alt="" style="height: 30px;vertical-align: middle;" />
            <% } %>
        </h1>
    </span>
    <div id="choose-country">
        Сортировать по стране: <%= Html.DropDownList("ddlCountryArticle", (IEnumerable<SelectListItem>)ViewData["ddlCountryArticle"])%> 
    </div>
    <span id="chooseregion">
        Регион: <%= Html.DropDownList("ddlDistrict", new List<SelectListItem>())%>  
        <br /><br /> 
    </span> 
    <% List<LinqToElcondor.TblSightseeing> list = (ViewData["CountryId"] == null) ? ElcondorBiz.BizSightseeing.GetSightseeingList() : ElcondorBiz.BizSightseeing.GetSightseeingListByCountryId(int.Parse(ViewData["CountryId"].ToString())); %>
    <div id="article-list-all-wrapper">
        <ul id="article-list-all">
            <% StringBuilder sb = new StringBuilder();
                foreach(LinqToElcondor.TblSightseeing itm in list) {
                    sb.Append("<li class=\"shadow-lr\">");   
                    sb.Append(string.Format("<a href=\"../../ViewArticle?id={0}\"><img src=\"../../Content/UserImages/sightseeing_th_{0}.jpg\" /></a>", itm.Id));
                    sb.Append(string.Format("<div class=\"article-descr\">"));
                    sb.Append(string.Format("<h4><a href=\"../../ViewArticle?id={0}\">{1}</a></h4>", itm.Id, ElcondorBiz.BizCountry.GetCountryById(itm.CountryId).Name));
                    sb.Append(string.Format("<div class=\"datestamp\">{0}</div>", itm.DateCreated.Value.ToString("dd.MM.yyyy")));
                    sb.Append(string.Format("{0}  &nbsp;<a href='../../ViewArticle?id={1}'>Подробнее...</a>", string.IsNullOrEmpty(itm.ShortDescription) ? string.Empty : itm.ShortDescription.Length > 180 ?
                                            itm.ShortDescription.Substring(0, itm.ShortDescription.IndexOf(" ", 160)) : itm.ShortDescription,itm.Id));
                    sb.Append("</div>");
                    sb.Append("</li>");
                }   
            %>
            <%= sb.ToString() %>
        </ul>
    </div>
   <%-- <%= ViewData["GridArticleList"]%>--%>
</asp:Content>
