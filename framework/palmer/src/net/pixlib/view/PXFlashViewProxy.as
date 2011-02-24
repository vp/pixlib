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
package net.pixlib.view
{
	import flash.display.MovieClip;

	/**
	 * The PXFlashViewProxy allow to bind automatically Flash Symbol as PXView.
	 * Sets the symbol base class to net.pixlib.view.PXFlashViewProxy
	 * 
	 * @example
	 * <listing>
	 *  //Symbol on stage
	 *  var sceneView : PXView = PXBasePlugin.getInstance().getView("myview");
	 *  
	 *  //Symbol in library
	 *	var clazz : Class = getDefinitionByName("Symbol1") as Class;
	 *	var instance : DisplayObject = new clazz();
	 *	instance.name = "attachedView";
	 *	addChild(instance);
	 *	
	 *	var libView : PXView = PXBasePlugin.getInstance().getView("attachedView");
	 *	trace(libView.name);
	 * </listing>
	 * 
	 * @see PXFlashView
	 * 
	 * @author Romain Ecarnot
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 */
	public class PXFlashViewProxy extends MovieClip
	{
		/**
		 * Stores the PXView reference. 
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		protected var _view : PXView;
		
		/**
		 * Indicates the instance name of the DisplayObject.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		override public function set name(value : String) : void
		{
			super.name = value;
			_view.name = value;
		}

		/**
		 * Creates new instance.
		 * 
		 * <p>Put this full qualified class name into base class property 
		 * for Flash ide clip.</p>
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXFlashViewProxy()
		{
			_view = new PXFlashView(name, this);
		}

		/**
		 * Returns the PXView created for the Flash element.
		 * 
		 * @return The PXView created for the Flash element.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function get view() : PXView
		{
			return _view;
		}
	}
}
