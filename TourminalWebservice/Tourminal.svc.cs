using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using BizUpgrade;

namespace TourminalWebservice {
    // ПРИМЕЧАНИЕ. Команду "Переименовать" в меню "Рефакторинг" можно использовать для одновременного изменения имени класса "Tourminal" в коде, SVC-файле и файле конфигурации.
    public class Tourminal : ITourminal {
        public string GetVariableById (int id) {
            return GetVariableById(id);
        }
    }
}
