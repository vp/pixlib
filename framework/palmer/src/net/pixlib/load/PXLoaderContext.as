/*
 * Copyright the original author or authors.
 * 
 * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.mozilla.org/MPL/MPL-1.1.html
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package net.pixlib.load
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;


	/**
	 * The PXLoaderContext class extends the LoaderContext to offer 
	 * a singleton access to application context.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXLoaderContext extends LoaderContext
	{
		/**
		 * Indicates if singleton instance use a policy file or not.
		 * 
		 * @default true
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static var CHECK_POLICY_FILE : Boolean = true;
		
		/**
		 * @private
		 */
		private static var _instance : PXLoaderContext;
		
		/**
		 * Returns singleton instance of PXLoaderContext.
		 * 
		 * <p>Check policy property is set to true and security level to null.</p>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public static function getInstance() : PXLoaderContext
		{
			if(!_instance) _instance = new PXLoaderContext(CHECK_POLICY_FILE, ApplicationDomain.currentDomain);
			
			return _instance;
		}
		
		/**
		 * Creates new PXLoaderContext instance.
		 * 
		 * @param checkPolicyFile	(default false) Specifies whether a 
		 * 							check should be made for the existence of 
		 * 							a URL policy file before loading the object.
		 * @param applicationDomain	(default null) Specifies the ApplicationDomain 
		 * 							object to use for a Loader object. 
		 * @param securityDomain	(default null) Specifies the SecurityDomain 
		 * 							object to use for a Loader object. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXLoaderContext(checkPolicyFile : Boolean = false, applicationDomain : ApplicationDomain = null, securityDomain : SecurityDomain = null)
		{
			super(checkPolicyFile, applicationDomain, securityDomain);
		}
	}
}
