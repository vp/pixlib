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
	import net.pixlib.plugin.PXBasePlugin;
	import net.pixlib.view.PXAbstractView;

	import flash.display.DisplayObject;

	/**
	 * The PXFlashView allow to bind automatically Flash Symbol as PXView.
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
	 * @see PXFlashViewProxy
	 * 
	 * @langversion 3.0
	 * @playerversion Flash 10
	 *
	 * @author Romain Ecarnot
	 */
	public class PXFlashView extends PXAbstractView
	{
		/**
		 * Creates new instance.
		 * 
		 * @param viewName	View's identifier.
		 * @param dpo		Display object element.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 */
		public function PXFlashView(viewName : String = null, dpo : DisplayObject = null)
		{
			super(PXBasePlugin.getInstance(), viewName, dpo);
		}
	}
}
