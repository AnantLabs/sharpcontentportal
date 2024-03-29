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
using System;
using System.Web;
using System.Web.Caching;

namespace SharpContent.UI.Utilities
{
    public class DataCache
    {
        public static object GetCache( string cacheKey )
        {
            Cache cache = HttpRuntime.Cache;
            return cache[cacheKey];
        }

        public static void RemoveCache( string cacheKey )
        {
            Cache cache = HttpRuntime.Cache;
            if( cache[cacheKey] == null )
            {
                return;
            }
            cache.Remove( cacheKey );
        }

        public static void SetCache( string cacheKey, object objObject, DateTime absoluteExpiration )
        {
            Cache cache = HttpRuntime.Cache;
            cache.Insert( cacheKey, objObject, null, absoluteExpiration, Cache.NoSlidingExpiration );
        }

        public static void SetCache( string cacheKey, object objObject )
        {
            Cache cache = HttpRuntime.Cache;
            cache.Insert( cacheKey, objObject );
        }

        public static void SetCache( string cacheKey, object objObject, int slidingExpiration )
        {
            Cache cache = HttpRuntime.Cache;
            cache.Insert( cacheKey, objObject, null, Cache.NoAbsoluteExpiration, TimeSpan.FromSeconds( slidingExpiration ) );
        }

        public static void SetCache( string cacheKey, object objObject, CacheDependency cacheDependency )
        {
            Cache cache = HttpRuntime.Cache;
            cache.Insert( cacheKey, objObject, cacheDependency );
        }

        public static void SetCache( string cacheKey, object objObject, CacheDependency cacheDependency, DateTime absoluteExpiration, TimeSpan slidingExpiration )
        {
            Cache cache = HttpRuntime.Cache;
            cache.Insert( cacheKey, objObject, cacheDependency, absoluteExpiration, slidingExpiration );
        }
    }
}