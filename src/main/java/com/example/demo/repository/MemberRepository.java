package com.example.demo.repository;

import org.apache.ibatis.annotations.Mapper;

import com.example.demo.vo.Article;
import com.example.demo.vo.Member;
import com.example.demo.vo.MemberImage;

@Mapper
public interface MemberRepository {

	public void doJoin(String provider, String providerId, String loginPw, String name, String email,
			String profileImage);

	public int getLastInsertId();

	public Member getMemberByLoingId(String loginId);

	public Member getMemberById(String provider, String providerId);

	public MemberImage getMemberImageIdByMemberId(int memberId);

	public void insertMemberImage(int memberId, String fileName, byte[] imageBytes);

	public void updateMemberImage(int memberId, String fileName, byte[] imageBytes);

	public MemberImage getMemberImageByMemberId(int memberId);

	public void doDelete(int memberId);

}
