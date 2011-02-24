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

	/**
	 * All loaders listener must implements this interface.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Francis Bourre
	 */
	public interface PXLoaderListener 
	{
		/**
		 * Triggered when loading starts.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onLoadStart( event : PXLoaderEvent ) : void;

		/**
		 * Triggered when loading is finished.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onLoadInit( event : PXLoaderEvent ) : void;

		/**
		 * Triggered during loading progession.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onLoadProgress( event : PXLoaderEvent ) : void;

		/**
		 * Triggered when the loading time causes a tiemout.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onLoadTimeOut( event : PXLoaderEvent ) : void;

		/**
		 * Triggered when an error occurs during loading.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onLoadError( event : PXLoaderEvent ) : void;
	}
}