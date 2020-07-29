function XANESHPRACTICE.Transform_Rotate2D(x,y,angle,originx,originy)
	local x1=x-originx
	local y1=y-originy
	local x2=x1*math.cos(angle)-y1*math.sin(angle)
	local y2=y1*math.cos(angle)+x1*math.sin(angle)
	x2=x2+originx
	y2=y2+originy

	return x2,y2
end

function XANESHPRACTICE.WrapAngle(angle)
	local result=angle
	while(result>math.pi)do result=result-math.pi*2 end
	while(result<=math.pi)do result=result+math.pi*2 end
	return result
end


function XANESHPRACTICE.signum(x)
	if x<0 then
		return -1
	elseif x>0 then
		return 1
	else
		return 0
	end
end



function XANESHPRACTICE.MatrixMultiplicationRotation(x,y,z,ax,ay,az)
	local x2=x
	local y2=y
	local z2=z

													
	x2,y2,z2=XANESHPRACTICE.MatrixMultiplication(x2,y2,z2,
										math.cos(az),-math.sin(az),0,
										math.sin(az),math.cos(az),0,
										0,0,1)		
	--print("After AZ:",x2,y2,z2)									
	x2,y2,z2=XANESHPRACTICE.MatrixMultiplication(x2,y2,z2,
										1,0,0,
										0,math.cos(ax),-math.sin(ax),
										0,math.sin(ax),math.cos(ax))
	--print("After AX:",x2,y2,z2)
	x2,y2,z2=XANESHPRACTICE.MatrixMultiplication(x2,y2,z2,
										math.cos(ay),0,math.sin(ay),
										0,1,0,
										-math.sin(ay),0,math.cos(ay))
	--print("After AY:",x2,y2,z2)
								
										
	return x2,y2,z2
end

function XANESHPRACTICE.MatrixMultiplicationRotation2(x,y,z,ax,ay,az)
	--TODO: by all rights this function should not work
	-- even if it did work it should cause everything else to break
	-- consult a mathematician
	local x2=x
	local y2=y
	local z2=z		
	x2,y2,z2=XANESHPRACTICE.MatrixMultiplication(x2,y2,z2,
										math.cos(ay),0,math.sin(ay),
										0,1,0,
										-math.sin(ay),0,math.cos(ay))
	x2,y2,z2=XANESHPRACTICE.MatrixMultiplication(x2,y2,z2,
										1,0,0,
										0,math.cos(ax),-math.sin(ax),
										0,math.sin(ax),math.cos(ax))
	x2,y2,z2=XANESHPRACTICE.MatrixMultiplication(x2,y2,z2,
										math.cos(az),-math.sin(az),0,
										math.sin(az),math.cos(az),0,
										0,0,1)		
	return x2,y2,z2
end

function XANESHPRACTICE.MatrixMultiplication(x,y,z,a00,a10,a20,a01,a11,a21,a02,a12,a22)
	local x2,y2,z2
	x2=x*a00+y*a10+z*a20
	y2=x*a01+y*a11+z*a21
	z2=x*a02+y*a12+z*a22
	return x2,y2,z2
end