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
package net.pixlib.core
{
	import net.pixlib.exceptions.PXUnimplementedMethodException;
	import net.pixlib.log.PXDebug;
	import net.pixlib.log.PXStringifier;
	import net.pixlib.utils.PXFlashVars;

	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.ui.ContextMenu;


	/**
	 * The PXBaseDocument class allow Pixlib internal auto initilization.
	 * Main document class must extends this class to allow correct framework 
	 * initialization.
	 * 
	 * <p>If you don't want to extend or use this class, don't allow to 
	 * initialize the framework using :</p>
	 * <listing>
	 * 
	 * PXApplication.getInstance().pixlib_internal::init(this, loaderInfo);
	 * </listing>
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXBaseDocument extends MovieClip
	{
		// --------------------------------------------------------------------
		// Public API
		// --------------------------------------------------------------------

		/**
		 * Returns the string representation of instance.
		 * 
		 * @return the string representation of instance
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		final override public function toString() : String
		{
			return PXStringifier.process(this);
		}

		// --------------------------------------------------------------------
		// Protected methods
		// --------------------------------------------------------------------

		/**
		 * @private
		 * 
		 * Triggered when document is added to application stage.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onAddedToStageHandler(event : Event) : void
		{
			event.stopImmediatePropagation();
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);

			addEventListener(Event.ENTER_FRAME, onInit);
		}

		/**
		 * @private
		 */
		protected function onInit(event : Event) : void
		{
			event.stopImmediatePropagation();
			removeEventListener(Event.ENTER_FRAME, onInit);

			PXApplication.getInstance().pixlib_internal::init(this, loaderInfo);

			init();
		}

		/**
		 * Initializes document properties.
		 * 
		 * <p>Set Stage default properties, hide context menu.</p>
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function init() : void
		{
			alignStage();
			initContextMenu();
			registerFlashVars();
			onDocumentReady();
		}

		/**
		 * Aligns application to top left point.
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.0
		 */
		protected function alignStage() : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		
		/**
		 * TODO Documentation
		 *
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 2.0
		 */
		protected function initContextMenu() : void
		{
			var menu : ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			contextMenu = menu;
		}

		/**
		 * @private 
		 * 
		 * Checks passed-in Flashvars
		 */
		protected function registerFlashVars() : void
		{
			var flashvars : PXFlashVars = PXFlashVars.getInstance();
			try
			{
				var param : Object = root.loaderInfo.parameters;
				for ( var p : String in param ) flashvars[p] = param[p];

				if (ExternalInterface.available)
				{
					try
					{
						var search : String = ExternalInterface.call("window.location.search.toString");

						if (search && search.length > 0)
						{
							if (search.indexOf("?") == 0) search = search.substr(1);

							var pair : Array = search.split("&");
							var len : uint = pair.length;
							var data : Array;
							for (var i : uint = 0; i < len; i++)
							{
								if (pair[i].indexOf("=") > -1)
								{
									data = pair[i].split("=");
									PXFlashVars.getInstance().register(data[0], data[1]);
								}
							}
						}
					}
					catch(ex : Error)
					{
						PXDebug.ERROR(ex.message, this);
					}
				}
			}
			catch ( e : Error )
			{
				PXDebug.ERROR(e.message, this);
			}
		}

		/**
		 * Triggered when application is ready to run. (configuration process 
		 * is complete).
		 * 
		 * <p>Overrides this method to define your behaviour here.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected function onDocumentReady() : void
		{
			throw new PXUnimplementedMethodException("onDocumentReady must be implemented !", this);
		}


		// --------------------------------------------------------------------
		// Private methods
		// --------------------------------------------------------------------

		/**
		 * @private
		 */
		function PXBaseDocument()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
	}
}
