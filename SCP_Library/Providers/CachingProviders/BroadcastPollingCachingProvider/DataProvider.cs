#region SharpContent License
// Sharp Content Portal - http://www.SharpContentPortal.com
// Copyright (c) 2002-2006
// by SharpContent Corporation
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
#endregion
using System.Data;
using SharpContent.Framework;

namespace SharpContent.Services.Cache.BroadcastPollingCachingProvider.Data
{
    public abstract class DataProvider
    {
        // provider constants - eliminates need for Reflection later
        private const string ProviderType = "data"; // maps to <sectionGroup> in web.config
        private const string ProviderNamespace = "SharpContent.Services.Cache.BroadcastPollingCachingProvider.Data"; // project namespace
        private const string ProviderAssemblyName = "SharpContent.Caching.BroadcastPollingCachingProvider"; // project assemblyname

        // singleton reference to the instantiated object
        private static DataProvider objProvider = null;

        // constructor
        static DataProvider()
        {
            CreateProvider();
        }

        // dynamically create provider
        private static void CreateProvider()
        {
            objProvider = (DataProvider)Reflection.CreateObject( ProviderType, ProviderNamespace, ProviderAssemblyName );
        }

        // return the provider
        public new static DataProvider Instance()
        {
            return objProvider;
        }

        public abstract IDataReader GetCachedObject( string Key );
        public abstract void AddCachedObject( string Key, string Value, string ServerName );
        public abstract void DeleteCachedObject( string Key );

        public abstract int AddBroadcast( string BroadcastType, string BroadcastMessage, string ServerName );
        public abstract IDataReader GetBroadcasts( string ServerName );
    }
}