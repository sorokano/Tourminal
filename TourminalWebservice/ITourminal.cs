using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.Threading;
using System.IO;
using System.Drawing;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web;
using System.Web.Services;
using Microsoft.Ajax.Samples;

namespace TourminalWebservice {
    // ПРИМЕЧАНИЕ. Команду "Переименовать" в меню "Рефакторинг" можно использовать для одновременного изменения имени интерфейса "ITourminal" в коде и файле конфигурации.
    [ServiceContract]
    public interface ITourminal {
        [OperationContract]
        [WebGet(ResponseFormat = WebMessageFormat.Json)]
        [JSONPBehavior(callback = "method")]
        string GetVariableById (int id);
    }
}
