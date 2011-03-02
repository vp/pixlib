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
package net.pixlib.share.strategy.sharing
{
	import net.pixlib.structures.PXDimension;
	import net.pixlib.share.PXSharingOptions;
	import net.pixlib.share.PXSharingStrategy;

	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;


	/**
	 * The PXAbstractSharingStrategy class is an abstract implementation to 
	 * share data on social networks or email for example.
	 * 
	 * <p>Take a look at concrete implementation like PXFacebookSharing or 
	 * PXTwitterSharing to see all available strategies.</p> 
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public class PXAbstractSharingStrategy implements PXSharingStrategy
	{
		/**
		 * @private
		 */
		private var _api : String;
		
		/**
		 * @private
		 */
		private var _size : PXDimension;

		/**
		 * Stores URLRequest property.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var apiRequest : URLRequest;

		/**
		 * Stores URLVariables property.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var apiVariables : URLVariables;
	

		/**
		 * @inheritDoc
		 */
		public function get service() : String
		{
			return _api;
		}

		/**
		 * @inheritDoc
		 */
		public function set service(value : String) : void
		{
			_api = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get request() : URLRequest
		{
			return apiRequest;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get variables() : URLVariables
		{
			return apiVariables;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get useOpenStrategy() : Boolean
		{
			return true;	
		}
		
		/**
		 * @inheritDoc
		 */
		public function get formSize() : PXDimension
		{
			return _size;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set formSize(value : PXDimension) : void
		{
			_size = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function share(text : String, url : String, options : PXSharingOptions = null) : void
		{
			buildVariables(text, url, options);

			apiRequest = new URLRequest(service);
			apiRequest.data = apiVariables;
			apiRequest.method = URLRequestMethod.GET;
		}
		
		/**
		 * @inheritDoc
		 */
		public function clear() : void
		{
			apiRequest = null;
			apiVariables = null;
		}
		
		/**
		 * Creates request variables.
		 * 
		 * @param text 		Shared text
		 * @param url		Shared content url
		 * @param options	(optional) Sharing options
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function buildVariables(text : String, url : String, options : PXSharingOptions = null) : void
		{
			
		}

		/**
		 * @private
		 */
		function PXAbstractSharingStrategy()
		{
			
		}
	}
}
