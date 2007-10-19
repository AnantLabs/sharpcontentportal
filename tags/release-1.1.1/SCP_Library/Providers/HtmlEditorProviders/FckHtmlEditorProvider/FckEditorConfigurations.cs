//
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
// by Perpetual Motion Interactive Systems Inc. ( http://www.perpetualmotion.ca )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
// documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and 
// to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions 
// of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED 
// TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
// DEALINGS IN THE SOFTWARE.
//
// File Author(s):
// Mauricio Márquez Anze - http://dnn.tiendaboliviana.com
//
// FCKeditor - The text editor for internet - http://www.fckeditor.net
// Copyright (C) 2003-2006 Frederico Caldeira Knabben
//

using System;
using System.Collections;
using System.Runtime.Serialization;

namespace SharpContent.HtmlEditor.FckHtmlEditorProvider
{

    [Serializable()]
    public class FckEditorConfigurations : ISerializable
    {

        private Hashtable _Configs;

        internal FckEditorConfigurations()
        {
            _Configs = new Hashtable();
        }

        protected FckEditorConfigurations(SerializationInfo info, StreamingContext context)
        {
            _Configs = (Hashtable)info.GetValue("ConfigTable", typeof(Hashtable));
        }

        public string this[string configurationName]
        {
            get
            {
                if (_Configs.ContainsKey(configurationName))
                {
                    return (string)_Configs[configurationName];
                }
                else
                {
                    return null;
                }
            }
            set { _Configs[configurationName] = value; }
        }


        internal string GetHiddenFieldString()
        {
            System.Text.StringBuilder osParams = new System.Text.StringBuilder();
            foreach (DictionaryEntry oEntry in _Configs)
            {
                if ((osParams.Length > 0))
                {
                    osParams.Append("&amp;");
                }
                osParams.AppendFormat("{0}={1}", EncodeConfig(oEntry.Key.ToString()), EncodeConfig(oEntry.Value.ToString()));
            }
            return osParams.ToString();
        }


        private string EncodeConfig(string valueToEncode)
        {
            string sEncoded = valueToEncode.Replace("&", "%26");
            sEncoded = sEncoded.Replace("=", "%3D");
            sEncoded = sEncoded.Replace("\"", "%22");
            return sEncoded;
        }

        #region ISerializable Members

        public void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context)
        {
            info.AddValue("ConfigTable", _Configs);
        }

        #endregion
    }
}
