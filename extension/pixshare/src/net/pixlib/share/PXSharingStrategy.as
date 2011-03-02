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
package net.pixlib.share
{
	import net.pixlib.structures.PXDimension;
	import flash.net.URLRequest;
	import flash.net.URLVariables;

	/**
	 * The PXSharingStrategy defines contract for all sharing concrete 
	 * implementations.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public interface PXSharingStrategy
	{
		/**
		 * The sharing service url.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get service() : String;
		
		/**
		 * @private
		 */
		function set service(value : String) : void;
		
		/**
		 * The runtime created URLRequest property.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get request() : URLRequest;
		
		/**
		 * The runtime created URLVariables property.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get variables() : URLVariables;
		
		/**
		 * Indicates if current strategy support "PXSendStrategy" system.
		 * If not, use direct "navigationToURL" method to send request.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get useOpenStrategy() : Boolean;
		
		/**
		 * Returns the size of opened form.
		 * 
		 * @return the size of opened form.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function get formSize() : PXDimension;
		
		/**
		 * @private
		 */
		function set formSize(value : PXDimension) : void;
		
		/**
		 * Shares passed-in informations on social networks or by email.
		 * 
		 * <p>Take a look at possible sharing strategies.</p>
		 * 
		 * <p>Strategy don't send request to the server, use a PXPostSharing 
		 * instance to send request.</p>
		 * 
		 * @param text 		Shared text
		 * @param url		Shared content url
		 * @param options	(optional) Sharing more options
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function share(text : String, url : String, options : PXSharingOptions = null) : void;
		
		/**
		 * Clears data.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function clear() : void
	}
}
