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
 
package net.pixlib.load.collection 
{
	import net.pixlib.load.PXLoaderEvent;
	import net.pixlib.load.PXLoaderListener;

	/**
	 * All collection loaders listener must implements this interface.
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * 
	 * @author Romain Ecarnot
	 */
	public interface PXLoaderCollectionListener extends PXLoaderListener
	{
		/**
		 * Triggered when an item loading starts.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onItemLoadStart( event : PXLoaderEvent ) : void;

		/**
		 * Triggered when an item loading is finished.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onItemLoadInit( event : PXLoaderEvent ) : void;

		/**
		 * Triggered during item loading progession.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onItemLoadProgress( event : PXLoaderEvent ) : void;

		/**
		 * Triggered when the item loading time causes a tiemout.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onItemLoadTimeOut( event : PXLoaderEvent ) : void;

		/**
		 * Triggered when an error occurs during item loading
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		function onItemLoadError( event : PXLoaderEvent ) : void;
	}
}
