package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.example.demo.repository.MemberRepository;
import com.example.demo.util.Ut;
import com.example.demo.vo.Member;
import com.example.demo.vo.MemberImage;
import com.example.demo.vo.ResultData;

@Service
public class MemberService {

	@Value("${custom.siteMainUri}")
	private String siteMainUri;
	@Value("${custom.siteName}")
	private String siteName;

	@Autowired
	private MemberRepository memberRepository;

	@Autowired
	private MailService mailService;

	public MemberService(MemberRepository memberRepository) {
		this.memberRepository = memberRepository;
	}

	public ResultData doJoin(String loginId, String loginPw, String name, String email) {

		memberRepository.doJoin("local", loginId, loginPw, name, email, null);
		int id = memberRepository.getLastInsertId();

		memberRepository.insertMemberImage(id, "", null);

		return ResultData.from("S-1", "로그인 성공", "memberId", id);
	}

	public Member getMemberById(String provider, String providerId) {

		return memberRepository.getMemberById(provider, providerId);
	}

	public void updateProfileImageData(int memberId, String fileName, byte[] imageBytes) {
		System.out.println(fileName);
		System.out.println(imageBytes);

		MemberImage memberImage = memberRepository.getMemberImageIdByMemberId(memberId);

		memberRepository.updateMemberImage(memberId, fileName, imageBytes);

	}

	public MemberImage getMemberImageByMemberId(int memberId) {
		return memberRepository.getMemberImageByMemberId(memberId);
	}

	public void doDelete(int memberId) {
		memberRepository.doDelete(memberId);

	}

	public Member getMemberByNameAndEmail(String name, String email) {

		return memberRepository.getMemberByNameAndEmail(name, email);
	}

	public ResultData notifyTempLoginPwByEmail(Member member) {
		String title = "[" + siteName + "] 임시 패스워드 발송";
		String tempPassword = Ut.getTempPassword(6);
		String body = "<h1>임시 패스워드 : " + tempPassword + "</h1>";
		body += "<a href=\"" + siteMainUri + "/usr/member/login\" target=\"_blank\">로그인 하러가기</a>";

		ResultData sendResultData = mailService.send(member.getEmail(), title, body);

		if (sendResultData.isFail()) {
			return sendResultData;
		}

		setTempPassword(member, tempPassword);

		return ResultData.from("S-1", "계정의 이메일주소로 임시 패스워드가 발송되었습니다.");
	}

	private void setTempPassword(Member member, String tempPassword) {
		memberRepository.updateMember(member.getId(), tempPassword, "", "");
	}

	public Member getMemberByProviderId(String providerId) {

		return memberRepository.getMemberByProviderId(providerId);
		
	}

	public void updateMember(int memberId, String name, String email, String loginPw) {

		memberRepository.updateMember(memberId, loginPw, name, email);
		
	}

}
