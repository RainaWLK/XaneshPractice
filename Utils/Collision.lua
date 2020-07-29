-- SOURCE: Stack Overflow 		https://stackoverflow.com/questions/1073336/circle-line-segment-collision-detection-algorithm
-- Mizipzor						https://stackoverflow.com/users/56763/mizipzor
-- smci							https://stackoverflow.com/users/202229/smci
-- bobobobobo					https://stackoverflow.com/users/111307/bobobobo
function XANESHPRACTICE.LineCircleCollision(x1,y1,x2,y2,cx,cy,r)

	local dot=function(v1,v2)		
			return v1[1]*v2[1]+v1[2]*v2[2]
		end
	local d={(x2-x1),(y2-y1)}
	local f={(x1-cx),(y1-cy)}
	
	
	local a=dot(d,d)
	local b=2*dot(f,d)
	local c=dot(f,f)-r*r
	
	local discriminant=b*b-4*a*c
	if(discriminant<0)then
		--print("discriminant<0")
		return false
	else
		discriminant=math.sqrt(discriminant)
		local t1=(-b - discriminant)/(2*a)
		local t2=(-b + discriminant)/(2*a)
		if(t1>=0 and t1<=1) then
			return true
		end
		if(t2>=0 and t2<=1) then
			return true
		end
		return false
	end
	
end